import pytest
import subprocess
import testinfra

@pytest.fixture(scope='session')
def host(request):
  docker_id = subprocess.check_output(['docker', 'run', '-d', 'docker/getting-started']).decode().strip()
  yield testinfra.get_host("docker://" + docker_id)
  subprocess.check_call(['docker', 'rm', '-f', docker_id])

def test_myimage01(host):
  assert host.check_output('uname -r') == '5.10.124-linuxkit'