const request = require('supertest');
const app = require('../server');

describe('Pruebas del servidor Express', () => {
  it('Debe responder en la ruta principal', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
  });

  it('Debe devolver información del servidor', async () => {
    const res = await request(app).get('/info');
    expect(res.body).toHaveProperty('message');
  });

  it('Debe devolver la hora actual', async () => {
    const res = await request(app).get('/time');
    expect(res.body).toHaveProperty('currentTime');
  });
});