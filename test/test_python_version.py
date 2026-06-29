import sys

EXPECT_PYTHON_VERSION = (3, 13)

def test_python_version():
    """ Ensure python version in use matches the expected python version. """
    assert sys.version_info.major == EXPECT_PYTHON_VERSION[0]
    assert sys.version_info.minor == EXPECT_PYTHON_VERSION[1]

