.PHONY: all flakes tests clean scss presentation

test_venv: requirements.txt node_requirements.txt
	rm -rf test_venv
	rm -rf node_env
	virtualenv test_venv

	bash -c 'source test_venv/bin/activate && \
		pip install -r requirements.txt && \
		nodeenv node_env --requirement=node_requirements.txt && \
		source node_env/bin/activate && \
		npm install bower && \
		npm install node-sass && \
		bower install'

scss: assets/yelp_reveal.css assets/presentation.css

presentation: scss
	(which google-chrome && google-chrome presentation.html) || \
	(which firefox && firefox presentation.html) &

clean: delete_fixtures
	rm -rf test_venv
	rm -rf node_env
	find . -iname '*.pyc' -delete

%.css: %.scss test_venv
	bash -c "source test_venv/bin/activate && \
		source node_env/bin/activate && \
		node-sass $^ -o $@"
