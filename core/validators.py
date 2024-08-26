import re

from django.core.exceptions import ValidationError


def validate_entity_handle(value):
    if re.search(r"^[^A-Z]", value):
        raise ValidationError("Must start with an UPPERCASE letter.")

    if re.search(r"[^A-Z0-9]$", value):
        raise ValidationError("Must end with an UPPERCASE letter or number.")

    if not re.search(r"^[A-Z][A-Z_0-9]+[A-Z0-9]$", value):
        raise ValidationError("Only letters, numbers and underscore allowed.")
