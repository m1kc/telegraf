import std.socket;
import std.socketstream;
import std.conv;
import core.thread;
import std.stdio;

__gshared Connection[] connections = new Connection[0];

class Connection : Thread
{
	Socket socket;
	SocketStream stream;
	string nickname = null;

	this()
	{
		super( &run );
    }

	void run()
	{
		// set nickname
		this.stream.write("Choose a nickname: ");
		string ans = to!string(this.stream.readLine());
		broadcast("-> " ~ ans);
		this.nickname = ans;
		// process messages
		while(true)
		{
			string msg = to!string(this.stream.readLine());
			broadcast(this.nickname ~ ": " ~ msg);
		}
	}
}

void broadcast(string msg)
{
	foreach(Connection c; connections)
	{
		if (c.nickname !is null)
		{
			c.stream.writeLine(msg);
		}
	}
}

void main()
{
	ushort port = 3214;

	auto listener = new TcpSocket();
	assert(listener.isAlive);
	listener.bind(new InternetAddress(port));
	listener.listen(10);

	while(true)
	{
		Thread.sleep(dur!("msecs")(100));
		Socket s = listener.accept();
		Connection conn = new Connection();
		conn.socket = s;
		conn.stream = new SocketStream(s);
		connections ~= conn;

		conn.start();
	}
}
