from hitchdoc.database import Database
from jinja2.environment import Environment
from jinja2 import FileSystemLoader
from path import Path


TEMPLATE_DIR = Path(__file__).realpath().dirname().joinpath("templates")


class Documentation(object):
    def __init__(self, sqlite_filename):
        self._db = Database(sqlite_filename)

        self.recordings = [
            {
                "name": recording.name,
                "slug": recording.slug,
                "steps": [
                    {"name": step.name} for step in self._db.Step.filter(recording=recording)
                ],
            } for recording in self._db.Recording.select()
        ]

    def generate(self):
        env = Environment()
        env.loader = FileSystemLoader(TEMPLATE_DIR)
        tmpl = env.get_template("default.jinja2")
        return tmpl.render(
            recordings=self.recordings,
        )
