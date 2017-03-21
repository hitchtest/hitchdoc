from peewee import ForeignKeyField, CharField, FloatField, BooleanField, DateTimeField, TextField
from peewee import SqliteDatabase, Model

class Database(object):
    def __init__(self, sqlite_filename):
        class BaseModel(Model):
            class Meta:
                database = SqliteDatabase(sqlite_filename)

        #class Story(BaseModel):
            #slug = CharField(primary_key=True)
            #name = CharField()

        class Recording(BaseModel):
            slug = CharField(primary_key=True)
            name = CharField()

        class Step(BaseModel):
            recording = ForeignKeyField(Recording)
            name = CharField()

        #if not Story.table_exists():
            #Story.create_table()
        if not Recording.table_exists():
            Recording.create_table()
        if not Step.table_exists():
            Step.create_table()

        self.BaseModel = BaseModel
        #self.Story = Story
        self.Recording = Recording
        self.Step = Step
