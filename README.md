# with-cached-open-file
## What is this?
Memoized version of CL:WITH-OPEN-FILE.

### Current lisp world
No such utilities.

### Issues
Accessing filesystem is slow.
Sometime we need to cache result.
Of course there is some libraries for memoization.
But in many case, it depends on argument.
File may modified even if pathname is same.
To satisfy such argument dependent memoization libraries,
you may change api.
(e.g. adding one more argument for fire-write-date.)

### Proposal
WITH-CACHED-OPEN-FILE is designed to easy using.
What you should do is just renaming CL:WITH-OPEN-FILE to WITH-CACHED-OPEN-FILE.

## Note
:DIRECTION :OUTPUT is not supported.

## From developer

### Product's goal

### License
MIT

### Tested with
SBCL/1.5.5

## Installation

