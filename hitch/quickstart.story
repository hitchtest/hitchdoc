Base story:
  params:
    python version: 3.5.0
  preconditions:
    python version: (( python version ))

Quickstart:
  based on: Base story
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
                self.doc.step("Did thing")

            def do_other_thing(self):
                self.doc.step("Did other thing")

  scenario:
    - Run: |
       from pathquery import pathq
       from hitchstory import StoryCollection
       from engine import Engine
       from path import Path
       import hitchdoc

       # Get recording
       print(StoryCollection(pathq(".").ext("story"), Engine()).one().play().report())

       # Create documentation
       assert Path("storydb.sqlite").exists()
       documentation = hitchdoc.Documentation('storydb.sqlite')
       output(documentation.generate())
    - Output will be:
       reference: simple-story-generated-doc
