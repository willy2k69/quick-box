VALUE=$(md5sum set_userpass.sh|awk '{print $1}')
echo $VALUE > set_userpass.checksum
svn ci -m 'updating checksum'
