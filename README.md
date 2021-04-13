zip_encrypter
=============
Simple script to do frequent encryption and decryption with the same password.

# INSTALLATION

## requirement
* ruby

## install
```
bundle install
```

## setting
```
write password in "password.txt"
```

### add alias

```
alias decrypt='ruby ~/path/to/zip_encrypter_ruby/decrypt.rb'
alias encrypt='ruby ~/path/to/zip_encrypter_ruby/encrypt.rb'
```

# USAGE

## encrypt
```
ruby encrypt.rb FILEPATH
```

## descript
```
ruby decrypt.rb FILEPATH
```

## all password update
```
ruby all_file_password_update.rb DIRPATH
```
