const readFile = require('fs')
const resolve = require('path')

module.exports = function appPlugin(fastify, _, done) {
	fastify.register(require('fastify-cors'));

	fastify.get('/', async (request, reply) => {
		readFile(resolve(__dirname, 'users.json'), 'utf8', (err, data) => {
			if (err) {
				console.log('File read failed:', err);
				reply.send('err: ' + err.toString())
				return;
			}
			if (request.query.term) {
				const result = JSON.parse(data).filter((elem) => elem.name.toLowerCase().search(request.query.term.toLowerCase()) !== -1);
				reply.send(JSON.stringify(result));
			}
			else {
				reply.send(data);
			}
		})
	})

	done()
}
