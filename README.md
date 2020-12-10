# macOS Bootstrap

A simple way to bootstrap a new machine.

## Set some sane defaults to start
```
./set-sane-preferences.sh
```

## Getting your Dotfiles with YADM
```
yadm clone https://gitlab.com/USER/dotfiles.git
yadm decrypt
```

## Installing non-free fonts

Some fonts I am using cannot be distributed freely. They can be installed with the following command:
```
curl -L https://bit.ly/2JViylU | bash
```


## Configuration

All configuration options can be found in `./CONFIG`

