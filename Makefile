all : ideone-vim.zip

remove-zip:
	-rm -f doc/tags
	-rm -f ideone-vim.zip

ideone-vim.zip: remove-zip
	zip -r ideone-vim.zip autoload plugin

release: ideone-vim.zip
	vimup update-script ideone.vim
