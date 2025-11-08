"""Tests for MEMOGEN CLI."""

import contextlib
from typing import Any
from unittest.mock import patch

from memogen.cli import main


class TestCLI:
    """Tests for command-line interface."""

    def test_version_flag(self, capsys: Any) -> None:
        """Test --version flag."""
        with patch("sys.argv", ["memogen", "--version"]):
            with contextlib.suppress(SystemExit):
                main()

            captured = capsys.readouterr()
            assert "MEMOGEN" in captured.out

    def test_help_output(self, capsys: Any) -> None:
        """Test help output."""
        with patch("sys.argv", ["memogen", "--help"]):
            with contextlib.suppress(SystemExit):
                main()

            captured = capsys.readouterr()
            assert "Master IELTS Vocabulary" in captured.out
