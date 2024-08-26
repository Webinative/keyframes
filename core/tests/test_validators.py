import pytest
from django.core.exceptions import ValidationError

from core.validators import validate_entity_handle


def test_validate_entity_handle():
    value = "a123"  # fail: does NOT start with uppercase letter
    with pytest.raises(ValidationError) as e_info:
        validate_entity_handle(value)

    assert e_info.value.message == "Must start with an UPPERCASE letter."

    value = "SIMPLE_"  # fail: ends with underscore
    with pytest.raises(ValidationError) as e_info:
        validate_entity_handle(value)

    assert e_info.value.message == "Must end with an UPPERCASE letter or number."

    value = "SOME_!_HANDLE"  # fail: contains special character
    with pytest.raises(ValidationError) as e_info:
        validate_entity_handle(value)

    assert e_info.value.message == "Only letters, numbers and underscore allowed."

    value = "SIMPLE_HANDLE"  # success
    validate_entity_handle(value)
