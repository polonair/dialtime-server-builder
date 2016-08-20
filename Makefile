.PHONY: all clean 

all:
	composer install
	mkdir -p build/DEBIAN
	mkdir -p build/etc/dialtime/server
	mkdir -p build/etc/cron.d
	mkdir -p build/usr/bin
	mkdir -p build/usr/share/doc/dialtime-server
	mkdir -p build/usr/share/dialtime/server/app
	mkdir -p build/usr/share/dialtime/server/vendor
	mkdir -p build/var/cache/dialtime/server
	mkdir -p build/var/lib/dialtime/server/records
	mkdir -p build/var/log/dialtime/server
	cp config/* build/etc/dialtime/server/
	cp bin/* build/usr/bin/
	cp app/* build/usr/share/dialtime/server/app/
	cp -r vendor/* build/usr/share/dialtime/server/vendor/
	cp -t build/DEBIAN deb/postinst deb/preinst deb/conffiles deb/config deb/templates
	sed -e "s/^Installed-size.*/Installed-size: `du -s build/ | grep -o [0-9]*`/" deb/control > build/DEBIAN/control
	cp deb-doc/* build/usr/share/doc/dialtime-server/
	gzip -9 build/usr/share/doc/dialtime-server/changelog
	cp cron/* build/etc/cron.d/
	chmod 0644 build/etc/dialtime/server/* build/usr/share/doc/dialtime-server/* build/DEBIAN/* build/etc/cron.d/dialtime-server
	chmod 0755 build/DEBIAN/postinst build/DEBIAN/preinst build/DEBIAN/config build/usr/bin/dialtime-server
	find build/usr/share/dialtime/server -type f -exec chmod 644 {} \;
	find build/usr/share/dialtime/server -type d -exec chmod 755 {} \;
	find build/usr/share/dialtime/server/vendor/ -name '.git*' -exec unlink {} \;
	find build/usr/share/dialtime/server/vendor/ -name 'LICENSE*' -exec unlink {} \;
	find build/usr/share/dialtime/server/vendor/ -name '*.sh' -exec chmod 775 {} \;
	cd build; find usr/ -type f -exec md5deep -rl {} \; >> DEBIAN/md5sums
	cd build; find etc/ -type f -exec md5deep -rl {} \; >> DEBIAN/md5sums
	chmod 0644 build/DEBIAN/md5sums
	mkdir ./out
	fakeroot dpkg-deb --build build ./out

clean:
	rm -rf build vendor out
	rm -rf composer.lock
	rm -rf *.deb
	find ./ -name '*~' -exec unlink {} \;
