# Controlfreak lookup

## Overview

The idea is to create a tool that can quickly lookup NIST 800-53 rev4 and rev5 controls on http://controlfreak.risk-redux.io and http://controlfreak5.risk-redux.io from the command line.

## Supported OS
### macOS
- Tested on macOS 10.15

### linux
- Tested on Ubuntu 20.04

## Usage

```
USAGE: args <r4 or r5> <control> [--show-all]

ARGUMENTS:
  <r4 or r5>              NIST 800-53 Revision, r4 or r5 
  <control>               800-53 control 

OPTIONS:
  --show-all
  -h, --help              Show help information.
```

## Building

The project was built on macOS 10.15.6.
