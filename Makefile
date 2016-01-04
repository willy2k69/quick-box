.PHONY: all test clean

test:
  curl -L https://raw.githubusercontent.com/JMSDOnline/quick-box/master/quickbox-apache.sh
  bash quickbox-apache.sh