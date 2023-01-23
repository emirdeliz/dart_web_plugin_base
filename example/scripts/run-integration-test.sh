#!/bin/bash
chromeDriverPort=4444
clientPort=9191

killProcessInPort() {
	lsof -P | grep ":$1" | awk '{print $2}' | xargs kill -9 && reset
}

startChromeDriver() {
	cd driver_test && ./chromedriver --port=$chromeDriverPort && cd ..
}

startFlutterIntegrationTest() {
	flutter drive \
		--driver=driver_test/integration_test.dart \
		--target=integration_test/dart_web_plugin_base_test.dart \
		-d web-server --web-port $clientPort --headless --release --keep-app-running

	# web-server chrome
}

main() {
	if [[ -z "$RUNNER_OS" ]]; then
		killProcessInPort $chromeDriverPort &&
			killProcessInPort $clientPort
	fi

	startChromeDriver &
	startFlutterIntegrationTest
}
main
