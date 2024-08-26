from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import User


@admin.register(User)
class CoreUserAdmin(UserAdmin):
    """Custom UserAdmin for core.User model"""

    list_display = ["username", "is_active", "is_staff", "is_superuser"]
    list_filter = ("is_staff",)
