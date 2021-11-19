import os, pytest, requests

def base_uri():
  thisenv = os.getenv('ENVIR')
  if thisenv == 'development':
    uri = "https://dev-cicddemo.terazo.com"
  if thisenv == 'uat':
    uri = "https://uat-cicddemo.terazo.com"
  if thisenv == 'production':
    uri = "https://cicddemo.terazo.com"

  return uri

def test_get_landing():
  landing_uri = base_uri()
  response = requests.get(landing_uri)
  assert response.status_code == 200
  assert response.json() == {'200': 'This is a landing page with no content.'}

def test_get_hello():
  get_hello_uri = base_uri() + "/v1/hello"
  response = requests.get(get_hello_uri)
  assert response.status_code == 200
  assert response.json() == {'200': 'Greetings and salutations.'}

def test_post_hello():
  post_hello_uri = base_uri() + "/v1/hello"
  response = requests.post(post_hello_uri)
  assert response.status_code == 405

def test_get_hello_dude():
  get_hello_dude_uri = base_uri() + "/v1/hello/"
  thesenames = ["dio", "enyaba", "holhorse"]
  for thisname in thesenames:
    response = requests.get(get_hello_dude_uri + thisname)
    assert response.status_code == 405

def test_post_hello_dude():
  post_hello_dude_uri = base_uri() + "/v1/hello/"
  thesenames = ["jotaro", "kakyoin", "avdol"]
  for thisname in thesenames:
    response = requests.post(post_hello_dude_uri + thisname)
    assert response.status_code == 201
    assert response.json() == {'201': f"And hello to you, {thisname}"}

def test_get_incorrect_path():
  get_wrong_uri = base_uri() + "/v1/floyd"
  response = requests.get(get_wrong_uri)
  assert response.status_code == 404
  assert response.json() == {'404': 'The requested path or resource was Not found'}
