PACKAGE = de.markusfisch.android.shadereditor
APK = app/build/outputs/apk/app-debug.apk

all: debug install start

debug:
	./gradlew assembleDebug

release: lint findbugs
	@./gradlew assembleRelease \
		-Pandroid.injected.signing.store.file=$(ANDROID_KEYFILE) \
		-Pandroid.injected.signing.store.password=$(ANDROID_STORE_PASSWORD) \
		-Pandroid.injected.signing.key.alias=$(ANDROID_KEY_ALIAS) \
		-Pandroid.injected.signing.key.password=$(ANDROID_KEY_PASSWORD)

lint:
	./gradlew lintDebug

findbugs:
	./gradlew findBugs

infer: clean
	infer -- ./gradlew assembleDebug

install:
	adb $(TARGET) install -r $(APK)

start:
	adb $(TARGET) shell 'am start -n \
		$(PACKAGE).debug/$(PACKAGE).activity.SplashActivity'

uninstall:
	adb $(TARGET) uninstall $(PACKAGE).debug

meminfo:
	adb shell dumpsys meminfo $(PACKAGE).debug

images:
	svg/update.sh

clean:
	./gradlew clean
