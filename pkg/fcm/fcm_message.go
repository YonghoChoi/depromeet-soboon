package fcm

import "encoding/json"

type IMessage interface {
	GetSender() string
	GetReceivers() []string
	GetTopic() []string
	GetData() map[string]string
	ToJson() (string, error)
}

// 참고 : https://firebase.google.com/docs/cloud-messaging/send-message?hl=ko
type Message struct {
	Receivers []string          `json:"receivers"`
	Title     string            `json:"title"`
	Body      string            `json:"body"`
	Topic     string            `json:"topic"`
	Data      map[string]string `json:"data"`
}

func (o *Message) GetReceivers() []string {
	return o.Receivers
}

func (o *Message) GetTopic() string {
	return o.Topic
}

func (o *Message) GetData() map[string]string {
	return o.Data
}

func (o *Message) ToJson() (string, error) {
	jsonBytes, err := json.Marshal(o)
	if err != nil {
		return "", err
	}

	return string(jsonBytes), nil
}
