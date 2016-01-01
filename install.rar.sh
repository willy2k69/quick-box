#!/bin/bash
wget http://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.2.7.tar.gz
	tar -xzf unrarsrc-5.2.7.tar.gz
	cd unrar
	make
	cp unrar /usr/bin
	cp unrar /usr/sbin
	cd ..
	rm -rf unrar*.tar.gz
	rm -rf ./unrar
