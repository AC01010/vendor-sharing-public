build: profiler.go
	rm -f profiler.exe
	go get github.com/sigurn/crc16
	GOOS=windows GOARCH=amd64 go build -a -tags meta -ldflags="-s -w -X 'main.BinID=$(binID)' -X 'main.copy=$(copy)' -X 'main.domain=$(domain)'" profiler.go