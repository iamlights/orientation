require "rails_helper"

RSpec.describe "Creating an article" do
  before { visit new_article_path }

  context "with valid parameters" do
    before do
      fill_in "article_title", with: "Test"
      fill_in "article_content", with: "This is a test"
      click_button "Create Article"
    end

    it "doesn't redirect to the new article page" do
      expect(current_path).to_not eq(new_article_path)
      expect(page).to have_content "Article was successfully created."
    end

    it "the author is subscribed" do
      last_article = Article.last
      expect(last_article.subscriptions.last.user).to eq(last_article.author)
    end
  end

  context "with invalid parameters" do
    context "with no content" do
      before do
        fill_in "article_title", with: "Test"
        fill_in "article_content", with: ""
        click_button "Create Article"
      end

      it "renders the new article page" do
        expect(page).to have_content("Create a New Article")
      end
    end

    context "with a reserved keyword" do
      before do
        fill_in "article_title", with: "new"
        fill_in "article_content", with: "Here is some content"
        click_button "Create Article"
      end

      it "renders the new article page" do
        expect(page).to have_content("Create a New Article")
        expect(page).to have_content("new is a reserved word.")
      end
    end
  end
end
