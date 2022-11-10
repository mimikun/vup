today = $(shell date "+%Y%m%d")
product_name = update_various

.PHONY : patch
patch : diff-patch

.PHONY : format-patch
format-patch :
	git format-patch origin/master

.PHONY : diff-patch
diff-patch :
	git diff origin/master > $(product_name).$(today).patch

.PHONY : patch-branch
patch-branch :
	git switch -c patch-$(today)

.PHONY : clean
clean :
	rm -f *.patch

