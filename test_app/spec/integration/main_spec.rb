require 'spec_helper'


feature 'executing Paloma controller', :js => true do

  describe 'after rendering' do

    it 'executes the corresponding Paloma controller action' do
      visit foo_path(1)
      called = page.evaluate_script 'window.called'

      expect(called).to include 'MyFoo#show'
    end


    context 'coming from a redirect' do
      before { visit foo_index_path }

      it 'executes first the Paloma action of the first Rails action' do
        first = page.evaluate_script 'window.called[0]'
        expect(first).to eq 'MyFoo#index'
      end

      it 'executes next the Paloma action of the last Rails action' do
        last = page.evaluate_script 'window.called.pop()'
        expect(last).to eq 'Main#index'
      end
    end


    context 'when js params is passed' do
      it 'passes the parameters to Paloma controller action' do
        visit foo_path(1)
        parameter = page.evaluate_script 'window.parameter'

        expect(parameter).to eq 'Parameter From Paloma'
      end
    end


    context 'from namespaced controller' do
      it 'executes the corresponding Paloma controller action' do
        visit admin_bar_path(1)
        called = page.evaluate_script 'window.called.pop()'

        expect(called).to eq 'Admin/Bar#show'
      end
    end


    context 'when js(false) is triggered' do
      it 'does not append paloma hook' do
        visit edit_foo_path(1)

        page.should_not have_selector '.js-paloma-hook'
      end
    end

  end

end