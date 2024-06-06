MODULES=*.js locale metadata.json stylesheet.css LICENSE.rst README.md
INSTALLPATH=~/.local/share/gnome-shell/extensions/ultradevtool@fernandohcorrea.com.br

all: compile-locales update-translations
# compile-settings

test: install nested-session

# compile-settings:
# 	glib-compile-schemas --strict --targetdir=schemas/ schemas

compile-locales:
	$(foreach file, $(wildcard locale/*/LC_MESSAGES/*.po), \
		msgfmt $(file) -o $(subst .po,.mo,$(file));)

update-translations:
	xgettext -L Python --from-code=UTF-8 -k_ -kN_ -o ultradevtool.pot *.js
	$(foreach file, $(wildcard locale/*/LC_MESSAGES/*.po), \
		msgmerge $(file) ultradevtool.pot -o $(file);)

install: all
	rm -rf $(INSTALLPATH)
	mkdir -p $(INSTALLPATH)
	cp -rv $(MODULES) $(INSTALLPATH)
	rm -f $(INSTALLPATH)/locale/*/LC_MESSAGES/*.po

nested-session:
	dbus-run-session -- env MUTTER_DEBUG_NUM_DUMMY_MONITORS=1 \
		MUTTER_DEBUG_DUMMY_MODE_SPECS=1280x720 \
		MUTTER_DEBUG_DUMMY_MONITOR_SCALES=1 gnome-shell --nested --wayland


bundle: all
	zip -FSr bundle.zip $(MODULES)
