package fcm

import (
	"context"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"fmt"
	"google.golang.org/api/option"
	"log"
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
		app, err := firebase.NewApp(ctx, nil, option.WithCredentialsFile("./soboon-service-account.json"))
		if err != nil {
			log.Fatalf(err.Error())
		}

		client, err := app.Messaging(ctx)
		if err != nil {
			log.Fatalf("error getting Messaging client: %v\n", err)
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
		fmt.Println("Successfully sent message:", response)
	}

	return nil
}
