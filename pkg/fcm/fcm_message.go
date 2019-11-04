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
	receivers []string
	topic     string
	data      map[string]string
}

func (o *Message) GetReceivers() []string {
	return o.receivers
}

func (o *Message) GetTopic() string {
	return o.topic
}

func (o *Message) GetData() map[string]string {
	return o.data
}

func (o *Message) ToJson() (string, error) {
	jsonBytes, err := json.Marshal(o)
	if err != nil {
		return "", err
	}

	return string(jsonBytes), nil
}
