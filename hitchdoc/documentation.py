from hitchdoc.database import Database
from jinja2.environment import Environment
from jinja2 import DictLoader
from strictyaml import load, MapPattern, Map, Str
from path import Path
import pickle
import base64


class Step(object):
    def __init__(self, step_db, step_templates):
        self._step_db = step_db
        self._step_templates = step_templates
        self.name = step_db.name
        self.kwargs = pickle.loads(base64.b64decode(step_db.kwargs))

    def __str__(self):
        env = Environment()
        env.loader = DictLoader(self._step_templates)
        return env.get_template(self.name).render(**self.kwargs)


class Documentation(object):
    def __init__(self, sqlite_filename, templates):
        self._db = Database(sqlite_filename)
        self._templates = load(
            Path(templates).bytes().decode('utf8'),
            Map({
                "documents": MapPattern(Str(), Str()),
                "steps": MapPattern(Str(), Str()),
            }),
        ).data

        self._stories = [
            {
                "name": recording.name,
                "slug": recording.slug,
                "steps": [
                    Step(
                        step_db,
                        self._templates['steps']
                    ) for step_db in self._db.Step.filter(recording=recording)
                ],
            } for recording in self._db.Recording.select()
        ]

    def write(self, template_name, filename):
        env = Environment()
        env.loader = DictLoader(self._templates['documents'])
        Path(filename).write_text(env.get_template(template_name).render(
            stories=self._stories,
        ))
