package log

import (
	"fmt"
	"github.com/sirupsen/logrus"
	"gopkg.in/natefinch/lumberjack.v2"
	"io"
	"os"
	"runtime"
)

type LoggerLogrus struct {
	Logger *logrus.Logger
}

func New(logLevel, fileName string, maxSize, maxBackups, maxAge int) Logger {
	//logLevel := "debug"
	//fileName := "./test.log"
	//maxSize := 100
	//maxBackups := 10
	//maxAge := 1

	level, err := logrus.ParseLevel(logLevel)
	if err != nil {
		panic(err)
	}

	logger := &logrus.Logger{
		Out:   os.Stderr,
		Level: level,
		Formatter: &logrus.TextFormatter{
			DisableColors:   true,
			TimestampFormat: "2006-01-02 15:04:05",
			FullTimestamp:   true,
		},
	}

	l := &lumberjack.Logger{
		Filename:   fileName,
		MaxSize:    maxSize,    // mb : 파일로그가 설정된 용량을 초과하면 로그 파일 로테이트
		MaxBackups: maxBackups, // 로그 로테이트 된 파일의 개수가 설정된 값을 초과하면 가장 오래된 파일 제거
		MaxAge:     maxAge,     // days : 로그 로테이트 주기
		Compress:   true,       // 로그 로테이트 시 압축 여부
	}

	logger.SetOutput(io.MultiWriter(l, os.Stdout))

	loggerLogrus := new(LoggerLogrus)
	loggerLogrus.Logger = logger
	return loggerLogrus
}

func getLoggerWithRuntimeContext(logger *logrus.Logger, skip int) *logrus.Entry {
	if pc, file, line, ok := runtime.Caller(skip); ok {
		funname := runtime.FuncForPC(pc).Name()
		logFields := logrus.Fields{}
		logFields["file"] = file
		logFields["func"] = funname
		logFields["line"] = line

		return logger.WithFields(logFields)
	}
	return nil
}

func isLimitLength(size int) bool {
	const MaxLogLength = 1000
	if size > MaxLogLength {
		return true
	}

	return false
}

func (o *LoggerLogrus) Debug(logType string, format string, args []interface{}) {
	msg := fmt.Sprintf(format, args...)
	if isLimitLength(len(msg)) { // 로그 길이가 너무 길어지는 경우 제한 ( 현재 임의로 1000)
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"log message size over. msg : %s ... \"}", logType, msg[0:100])
	} else {
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"%s\"}", logType, msg)
	}

	entry := getLoggerWithRuntimeContext(o.Logger, 3)
	if entry != nil {
		entry.Debug(msg)
	} else {
		o.Logger.Debug(msg)
	}
}

func (o *LoggerLogrus) Info(logType string, format string, args []interface{}) {
	msg := fmt.Sprintf(format, args...)
	if isLimitLength(len(msg)) { // 로그 길이가 너무 길어지는 경우 제한 ( 현재 임의로 1000)
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"log message size over. msg : %s ... \"}", logType, msg[0:100])
	} else {
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"%s\"}", logType, msg)
	}

	entry := getLoggerWithRuntimeContext(o.Logger, 3)
	if entry != nil {
		entry.Info(msg)
	} else {
		o.Logger.Info(msg)
	}
}

func (o *LoggerLogrus) Warn(logType string, format string, args []interface{}) {
	msg := fmt.Sprintf(format, args...)
	if isLimitLength(len(msg)) { // 로그 길이가 너무 길어지는 경우 제한 ( 현재 임의로 1000)
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"log message size over. msg : %s ... \"}", logType, msg[0:100])
	} else {
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"%s\"}", logType, msg)
	}

	entry := getLoggerWithRuntimeContext(o.Logger, 3)
	if entry != nil {
		entry.Warn(msg)
	} else {
		o.Logger.Warn(msg)
	}
}

func (o *LoggerLogrus) Error(logType string, format string, args []interface{}) {
	msg := fmt.Sprintf(format, args...)
	if isLimitLength(len(msg)) { // 로그 길이가 너무 길어지는 경우 제한 ( 현재 임의로 1000)
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"log message size over. msg : %s ... \"}", logType, msg[0:100])
	} else {
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"%s\"}", logType, msg)
	}

	entry := getLoggerWithRuntimeContext(o.Logger, 3)
	if entry != nil {
		entry.Error(msg)
	} else {
		o.Logger.Error(msg)
	}
}

func (o *LoggerLogrus) Fatal(logType string, format string, args []interface{}) {
	msg := fmt.Sprintf(format, args...)
	if isLimitLength(len(msg)) { // 로그 길이가 너무 길어지는 경우 제한 ( 현재 임의로 1000)
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"log message size over. msg : %s ... \"}", logType, msg[0:100])
	} else {
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"%s\"}", logType, msg)
	}

	entry := getLoggerWithRuntimeContext(o.Logger, 3)
	if entry != nil {
		entry.Fatal(msg)
	} else {
		o.Logger.Fatal(msg)
	}
}

func (o *LoggerLogrus) Panic(logType string, format string, args []interface{}) {
	msg := fmt.Sprintf(format, args...)
	if isLimitLength(len(msg)) { // 로그 길이가 너무 길어지는 경우 제한 ( 현재 임의로 1000)
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"log message size over. msg : %s ... \"}", logType, msg[0:100])
	} else {
		msg = fmt.Sprintf("{\"type\": \"%s\", \"msg\": \"%s\"}", logType, msg)
	}

	entry := getLoggerWithRuntimeContext(o.Logger, 3)
	if entry != nil {
		entry.Panic(msg)
	} else {
		o.Logger.Panic(msg)
	}
}
