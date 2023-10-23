"use strict";

import Fastify from "fastify";
import appPlugin from "../server-vercel";

const app = Fastify({
	logger: true,
});

app.register(appPlugin);

export default async (req, res) => {
	await app.ready();
	app.server.emit('request', req, res);
}
