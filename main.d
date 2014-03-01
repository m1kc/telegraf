import core.thread;
import std.string;
import std.stdio;
import std.conv;
import std.socket;
import std.socketstream;

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
		this.stream.writeString("Choose a nickname: ");
		string ans = to!string(this.stream.readLine());
		broadcast("-> " ~ ans);
		this.nickname = ans;
		this.stream.writeLine("Welcome again, " ~ ans ~ ". New messages will be displayed below.");
		// process messages
		while(true)
		{
			string msg = to!string(this.stream.readLine());
			if (msg.strip().length > 0) broadcast(this.nickname ~ ": " ~ msg);
			if (!this.socket.isAlive)
			{
				//writeln("disconnect");
				break;
			}
		}
	}
}

void broadcast(string msg)
{
	writeln(msg);
	foreach(Connection c; connections)
	{
		if (c.nickname !is null)
		{
			try
			{
				c.stream.writeLine(msg);
			}
			catch(Exception e)
			{
				// probably disconnected, do nothing
			}
		}
	}
}

void main(string[] args)
{
	ushort port = 3214;
	if (args.length > 1)
	{
		if (args[1] == "-h" || args[1] == "--help")
		{
			writeln("Usage: telegraf [port]");
			return;
		}
		else
		{
			port = parse!ushort(args[1]);
		}
	}

	auto listener = new TcpSocket();
	assert(listener.isAlive);
	listener.bind(new InternetAddress(port));
	listener.listen(10);

	writeln("Ready to rock. Port " ~ to!string(port) ~ ".");

	while(true)
	{
		Socket s = listener.accept();
		Connection conn = new Connection();
		conn.socket = s;
		conn.stream = new SocketStream(s);
		connections ~= conn;

		conn.start();
	}
}
