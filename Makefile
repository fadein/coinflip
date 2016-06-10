.PHONY: clean

flip: flip.scm
	csc $^

clean:
	-rm -f flip
