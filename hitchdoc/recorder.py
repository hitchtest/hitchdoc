from hitchdoc.database import Database


class Recorder(object):
    def __init__(self, story, sqlite_filename):
        self._story = story
        self._db = Database(sqlite_filename)

        self._model = self._db.Recording(
            name=story.name,
            slug=story.slug,
        )
        self._model.save(force_insert=True)

    def step(self, name, **kwargs):
        new_step = self._db.Step(recording=self._model, name=name)
        new_step.save()
