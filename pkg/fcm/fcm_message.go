package fcm

import "encoding/json"

type Message interface {
	GetSender() string
	GetReceivers() []string
	GetTopic() []string
	GetData() map[string]string
	ToJson() (string, error)
}

type FCMMessage struct {
	message   string
	receivers []string
	sender    string
	topic     string
	data      map[string]string
}

func (o *FCMMessage) GetSender() string {
	return o.sender
}

func (o *FCMMessage) GetReceivers() []string {
	return o.receivers
}

func (o *FCMMessage) GetMessage() string {
	return o.message
}

func (o *FCMMessage) GetTopic() string {
	return o.topic
}

func (o *FCMMessage) GetData() map[string]string {
	return o.data
}

func (o *FCMMessage) ToJson() (string, error) {
	jsonBytes, err := json.Marshal(o)
	if err != nil {
		return "", err
	}

	return string(jsonBytes), nil
}
