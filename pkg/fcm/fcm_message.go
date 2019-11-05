package fcm

import "encoding/json"

type IMessage interface {
	GetSender() string
	GetReceivers() []string
	GetTopic() []string
	GetData() map[string]string
	ToJson() (string, error)
}

type Message struct {
	Receivers []string          `json:"receivers"`
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
