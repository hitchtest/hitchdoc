Multiple pages:
  based on: HitchDoc
  description: |
    Generating documentation that includes multiple pages -
    one for each story.
  preconditions:
    files:
      simple.story: |
        First simple story:
          description: |
            This description should explain
            why this story exists.
          scenario:
            - do thing
            - do other thing

        Second simple story:
          description: |
            This description should explain
            why this second story exists.
          scenario:
            - do thing
      engine.py: |
        from hitchstory import BaseEngine, StorySchema
        from strictyaml import Str
        import hitchdoc

        class Engine(BaseEngine):
            schema = StorySchema(
                about={
                    "description": Str(),
                }
            )

            def set_up(self):
                self.doc = hitchdoc.Recorder(
                    hitchdoc.HitchStory(self),
                    'storydb.sqlite',
                )

            def do_thing(self):
                self.doc.step("thing", var=1)

            def do_other_thing(self):
                self.doc.step("other-thing", val=2)
      templates.yml: |
        documents:
          rst: |
            {{ story.name }}
            {{ "-" * story.name|length }}

            {{ story['description'] }}

            {%- for step in story.steps %}
            * {{ step }}
            {%- endfor %}
        steps:
          thing: Did thing {{ var }}
          other-thing: Did other thing {{ val }}
  scenario:
    - Run: |
       from pathquery import pathq
       from hitchstory import StoryCollection
       from engine import Engine
       from path import Path
       import hitchdoc

    - Run: |
       # Make recording of story outputs
       stories = StoryCollection(pathq(".").ext("story"), Engine())
       print(stories.ordered_by_name().play().report())

    - Run: |
       # Create documentation
       documentation = hitchdoc.Documentation('storydb.sqlite', 'templates.yml')

       for story in documentation.stories:
           story.write("rst", "{0}.rst".format(story.slug))

    - File contents will be:
       filename: first-simple-story.rst
       reference: first-simple-story

    - File contents will be:
       filename: second-simple-story.rst
       reference: second-simple-story
