# MODULES = *.js locale/*/LC_MESSAGES/*.mo metadata.json stylesheet.css LICENSE.rst README.md
MODULES = *.js metadata.json stylesheet.css LICENSE.rst README.md
INSTALLPATH=~/.local/share/gnome-shell/extensions/ultradevtool@fernandohcorrea.com.br

# all: compile-locales compile-settings update-po-files

test: install nested-session

# compile-settings:
# 	glib-compile-schemas --strict --targetdir=schemas/ schemas

# compile-locales:
# 	$(foreach file, $(wildcard locale/*/LC_MESSAGES/*.po), \
# 		msgfmt $(file) -o $(subst .po,.mo,$(file));)

# update-po-files:
# 	xgettext -L Python --from-code=UTF-8 -k_ -kN_ -o ultradev.pot *.js
# 	$(foreach file, $(wildcard locale/*/LC_MESSAGES/*.po), \
# 		msgmerge $(file) ultradev.pot -o $(file);)

install:
	rm -rf $(INSTALLPATH)
	mkdir -p $(INSTALLPATH)
	cp -r $(MODULES) $(INSTALLPATH)

nested-session:
	dbus-run-session -- env MUTTER_DEBUG_NUM_DUMMY_MONITORS=1 \
		MUTTER_DEBUG_DUMMY_MODE_SPECS=1280x720 \
		MUTTER_DEBUG_DUMMY_MONITOR_SCALES=1 gnome-shell --nested --wayland


bundle:
	zip -FSr bundle.zip $(MODULES)
