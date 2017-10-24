TEST_PATH=tests

setup-venv:
	mkdir -p venv
	rm -rf venv
	mkdir venv
	virtualenv venv
	venv/bin/pip install -U pip-tools
	venv/bin/pip-compile --upgrade requirements.in --output-file requirements.txt
	venv/bin/pip-compile --upgrade requirements-dev.in --output-file requirements-dev.txt
	venv/bin/pip install -r requirements-dev.txt


clean-pyc:
	find . -name '*.pyc' -exec rm --force {} +
	find . -name '*.pyo' -exec rm --force {} +
	find . -name '*~' -exec rm --force  {} +

clean-build:
	rm --force --recursive build/
	rm --force --recursive dist/
	rm --force --recursive *.egg-info

isort:
	sh -c "isort --skip-glob=.tox --recursive . "

lint:
	venv/bin/flake8 --exclude=.tox

test: clean-pyc
	venv/bin/py.test --verbose --color=yes $(TEST_PATH)

run:
	venv/bin/python manage.py runserver

docker-run:
	docker build \
	  --file=./Dockerfile \
	  --tag=my_project ./
	docker run \
	  --detach=false \
	  --name=my_project \
	  --publish=$(HOST):8080 \
	  my_project

