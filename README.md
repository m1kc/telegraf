telegraf
========

Telnet chat. Server is written in D.


Compiling
---------

Just type `make`.


Usage
-----

### Server

```sh
$ ./main
Ready to rock. Port 3214.
```

```sh
$ ./main 2222
Ready to rock. Port 2222.
```

### Client

```sh
$ telnet 1.2.3.4 3214
Trying 1.2.3.4...
Connected to 1.2.3.4.
Escape character is '^]'.
Choose a nickname: m1kc
Welcome again, m1kc. New messages will be displayed below.
```

```sh
$ netcat 1.2.3.4 3214
Choose a nickname: m1kc
Welcome again, m1kc. New messages will be displayed below.
```

**Tip:** netcat works better with Russian letters.
