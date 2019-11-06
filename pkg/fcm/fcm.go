package fcm

import (
	"context"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/YonghoChoi/depromeet-soboon/pkg/log"
	"google.golang.org/api/option"
	"os"
)

var gSender *Sender

type Sender struct {
	client *messaging.Client
	ctx    context.Context
}

func (o *Sender) GetCtx() context.Context {
	return o.ctx
}

func (o *Sender) GetClient() *messaging.Client {
	return o.client
}

func (o *Sender) Send(message *messaging.Message) (string, error) {
	return o.client.Send(o.GetCtx(), message)
}

func getFCMClient() *Sender {
	if gSender == nil {
		ctx := context.Background()
		credentials := os.Getenv("FIREBASE_CREDENTIALS")
		if credentials == "" {
			credentials = "./soboon-service-account.json"
		}
		app, err := firebase.NewApp(ctx, nil, option.WithCredentialsFile(credentials))
		if err != nil {
			log.Fatal("fcm", err.Error())
		}

		client, err := app.Messaging(ctx)
		if err != nil {
			log.Fatal("fcm", "error getting Messaging client: %v", err)
		}

		gSender = new(Sender)
		gSender.client = client
		gSender.ctx = ctx
	}

	return gSender
}

func Send(fcmMessage *Message) error {
	// topic에 구독하고 있는 구독자들한테 메시지 전송
	// 참고 : https://firebase.google.com/docs/cloud-messaging/android/send-multiple?authuser=0
	c := getFCMClient()
	message := &messaging.Message{
		Data:  fcmMessage.GetData(),
		Topic: fcmMessage.GetTopic(),
	}

	for _, receiver := range fcmMessage.GetReceivers() {
		message.Token = receiver
		response, err := c.Send(message)
		if err != nil {
			return err
		}
		// Response is a message ID string.
		log.Debug("fcm", "Successfully sent message: %s", response)
	}

	return nil
}
