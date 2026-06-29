VENV_PYTHON:=.venv/bin/python
SRCS:=$(shell find src tests -name '*.py')

all: test

# `make python-version` is used by GitHub actions to echo 
# the expected version of Python into .python-version
PYTHON_VERSION:=$(shell PYTHONPATH=tests python3 -c 'from test_python_version import EXPECT_PYTHON_VERSION as V; print(f"{V[0]}.{V[1]}")')
python-version:
	@echo $(PYTHON_VERSION)

.venv: requirements-test.in requirements.in
	rm -rf $@
	python -m venv .venv
	$(VENV_PYTHON) -m pip install -r $^
# Install dependencies from pyproject.toml
	$(VENV_PYTHON) -m pip install -e .

lint: .venv .lint
.lint: $(SRCS) $(TSCS)
	$(VENV_PYTHON) -m flake8 $?
	touch $@

static: .venv .static
.static: $(SRCS) $(TSCS)
	echo "Code: $(SRCS)"
	echo "Test: $(TSCS)"
	$(VENV_PYTHON) -m mypy $^
	touch $@

autopep8:
	autopep8 --in-place $(SRCS)

unit: .venv
	$(VENV_PYTHON) -m pytest

test: lint static unit

clean:
	rm -rf .lint .static
	rm -rf .mypy_cache
	-find src -type d -name __pycache__ -exec rm -fr "{}" \;

force-clean: clean
	rm -rf .venv
