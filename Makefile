.PHONY: all test clean

test:
  git clone https://github.com/JMSDOnline/quick-box.git ~/tmp/quick-box/
  curl -L https://raw.githubusercontent.com/JMSDOnline/quick-box/master/quickbox-apache.sh
  quickbox-apache.sh