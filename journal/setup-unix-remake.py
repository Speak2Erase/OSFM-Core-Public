"""
This is a setup.py script generated by py2applet

Usage:
    python3 setup-unix-remake.py py2app
"""

from setuptools import setup

APP = ['journal.py']
APP_NAME = "_______"
DATA_FILES = ["images"]
OPTIONS = {
	'argv_emulation': True,
	# 'plist': {
	# 	'CFBundleName': APP_NAME,
	# 	'CFBundleDisplayName': APP_NAME,
	# 	'CFBundleGetInfoString': "You only have one shot.",
	# 	'CFBundleIdentifier': 'com.oneshot-game.hunternet93.journal-remake',
	# 	'CFBundleVersion': '1.0',
	# 	'CFBundleShortVersionString': '1.0',
	# 	'LSApplicationCategoryType': 'public.app-category.games',
	# 	'LSMinimumSystemVersion': '10.7',
	# 	'NSHumanReadableCopyright': u"Copyright © 2017, hunternet93 and Vinyl Darkscratch, MIT License. https://github.com/hunternet93/OneShot-Journal"
	# }
}

setup(
	name=APP_NAME,
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)