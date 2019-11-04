package fcm

import (
	"context"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"google.golang.org/api/option"
	"log"
)

var gClient *FCMClient

type FCMClient struct {
	client *messaging.Client
	ctx    context.Context
}

func getFirebaseClient() *FCMClient {
	if gClient == nil {
		ctx := context.Background()
		app, err := firebase.NewApp(ctx, nil, option.WithCredentialsFile("../../private/soboon-service-account.json"))
		if err != nil {
			log.Fatalf(err.Error())
		}

		client, err := app.Messaging(ctx)
		if err != nil {
			log.Fatalf("error getting Messaging client: %v\n", err)
		}

		gClient = new(FCMClient)
		gClient.client = client
		gClient.ctx = ctx
	}

	return gClient
}

func Send(fcmMessage *FCMMessage) {
	// topic에 구독하고 있는 구독자들한테 메시지 전송
	// 참고 : https://firebase.google.com/docs/cloud-messaging/android/send-multiple?authuser=0
	message := &messaging.Message{
		Data:  fcmMessage.GetData(),
		Topic: fcmMessage.GetTopic(),
	}

	for _, receiver := range fcmMessage.GetReceivers() {
		response, err := gClient.Send(ctx, message)
		if err != nil {
			log.Fatalln(err)
		}
		// Response is a message ID string.
		fmt.Println("Successfully sent message:", response)
	}

	message := &messaging.Message{
		Data:  fcmMessage.GetData(),
		Token: registrationToken,
		Topic: topic,
	}

	// Send a message to the device corresponding to the provided
	// registration token.
	response, err := client.Send(ctx, message)
	if err != nil {
		log.Fatalln(err)
	}
	// Response is a message ID string.
	fmt.Println("Successfully sent message:", response)
}
