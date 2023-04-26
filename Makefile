PREFIX ?= ${HOME}/.config/lvim

install:
	mkdir -p "${DESTDIR}${PREFIX}/colors"

	cp -f config.lua "${DESTDIR}${PREFIX}"
	chmod 664 "${DESTDIR}${PREFIX}/config.lua"

	cp -f colors/* "${DESTDIR}${PREFIX}/colors"
	chmod 664 "${DESTDIR}${PREFIX}"/colors/*
