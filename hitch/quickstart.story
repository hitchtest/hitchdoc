HitchDoc:
  params:
    python version: 3.5.0
  preconditions:
    python version: (( python version ))

HitchDoc Quickstart:
  based on: HitchDoc
  preconditions:
    files:
      simple.story: |
        Simple story:
          scenario:
            - do thing
            - do other thing
      engine.py: |
        from hitchstory import BaseEngine
        import hitchdoc

        class Engine(BaseEngine):
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
          readme: |
            Example title
            =============

            {% for story in stories %}
            {{ story.name }}
            ----------------
            {% for step in story.steps %}
            * {{ step }}
            {% endfor %}
            {% endfor %}
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
       # Make recording of story output
       stories = StoryCollection(pathq(".").ext("story"), Engine())
       print(stories.one().play().report())

    - Run: |
       # Create documentation   
       documentation = hitchdoc.Documentation('storydb.sqlite', 'templates.yml')
       documentation.write("readme", "README.rst")

    - File contents will be:
       filename: README.rst
       reference: simple-generated-readme
