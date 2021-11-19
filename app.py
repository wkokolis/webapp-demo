from flask import Flask, jsonify, abort, make_response, request
from demo import Demo

CONFIG = {"version": "v0.0.1", "config": "dev"}
app = Flask(__name__)

## Routes

@app.route('/')
def index():
  return make_response(jsonify({'200': 'This is a landing page with no content.'}), 200)

@app.route('/v1/liveness')
def health_check():
  return make_response(jsonify({'200': 'IAMOK'}), 200)

@app.route('/v1/hello', methods=['GET'])
def i_said_hi():
  return make_response(jsonify({'200': 'Greetings and salutations.'}), 200)

@app.route('/v1/hello/<yourname>', methods=['POST'])
def who_are_you(yourname):
  text_response={'201': f"And hello to you, {yourname}"}
  return make_response(jsonify(text_response), 201)

@app.route('/v1/number', methods=['GET'])
def pick_a_number():
  number_response = {}

  demo_math = Demo()

  number_response = demo_math.get_mods()

  return make_response(jsonify(number_response))

## Error-handling
@app.errorhandler(404)
def not_found(error):
  return make_response(jsonify({'404': 'The requested path or resource was Not found'}), 404)

@app.errorhandler(400)
def bad_request(error):
  return make_response(jsonify({'400': 'Bad request or malformed payload'}), 400)

@app.errorhandler(405)
def not_allowed(error):
  return make_response(jsonify({'405': 'Method not implemented for this endpoint'}), 405)

## Pull the lever, Kronk!
if __name__ == '__main__':
  app.run(host='0.0.0.0', port=5000)
