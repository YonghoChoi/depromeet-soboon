package log

type Logger interface {
	Debug(logType string, format string, args []interface{})
	Info(logType string, format string, args []interface{})
	Warn(logType string, format string, args []interface{})
	Error(logType string, format string, args []interface{})
	Fatal(logType string, format string, args []interface{})
	Panic(logType string, format string, args []interface{})
}

var inst Logger

func Init(logLevel, logPath string) {
	inst = New(logLevel, logPath, 100, 10, 1)
}

func Debug(logType string, format string, args ...interface{}) {
	inst.Debug(logType, format, args)
}

func Info(logType string, format string, args ...interface{}) {
	inst.Info(logType, format, args)
}

func Warn(logType string, format string, args ...interface{}) {
	inst.Warn(logType, format, args)
}

func Error(logType string, format string, args ...interface{}) {
	inst.Error(logType, format, args)
}

func Fatal(logType string, format string, args ...interface{}) {
	inst.Fatal(logType, format, args)
}

func Panic(logType string, format string, args ...interface{}) {
	inst.Panic(logType, format, args)
}
