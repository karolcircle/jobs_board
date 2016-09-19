require 'rails_helper'

RSpec.describe JobsController, type: :controller do
   include Devise::Test::ControllerHelpers
   let!(:job) { FactoryGirl.create(:job) }
   let(:other_job) { FactoryGirl.build(:job) }
   let!(:category) { FactoryGirl.create(:category) }
   let!(:user) { FactoryGirl.create(:user) }

    context "when user is not authenticated" do
      context "index" do
        it "renders template index" do
          get :index
          expect(response).to render_template(:index)
        end
      end

      context "#new" do
        it "redirects to sign in page" do
          get :new
          expect(response).to redirect_to(new_user_session_path)
        end
      end
      
      context "#edit" do
        it "redirects to sign in page" do
          get :edit, params: { id: job.id }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "#update" do
        it "redirects to sign in page" do
          patch :update, params: { id: job.id, job: FactoryGirl.attributes_for(:job) }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "#create" do
        it "redirects to sign in page" do
          post :create, params: { job: FactoryGirl.attributes_for(:job) }
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context "show" do
        it "renders template show" do
          get :show, params: { id: job.id }
          expect(response).to render_template(:show)
        end
      end

      context "destroy" do
        it "redirects to sign in page" do
          delete :destroy, params: { id: job.id }
          expect(response).to redirect_to(new_user_session_path)
        end
      end 
    end

    context "when user is authenticated" do
      before { sign_in(user) }

      describe "GET #index" do
        before { get :index }

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders template index" do
          expect(response).to render_template(:index)
        end
      end
   
      describe "GET #show" do
        before { get :show, params: { id: job.id } }

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to have_http_status(200)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    describe "GET #edit" do
        before { get :edit, params: { id: job.id } }

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to have_http_status(200)
      end

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end
    end

    describe "POST #create" do
      before { post :create, params: { job: other_job.attributes } }

      it "returns http success" do
        expect(response).to have_http_status(:found)
      end

      it "redirects to job show page" do
        expect(response).to redirect_to assigns(:job)
      end
    end

    describe "GET #new" do
      before { get :new }

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to have_http_status(200)
      end

      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end

    describe "PUT #update" do
      let(:attr) { FactoryGirl.attributes_for(:job, title: "Ruby Developer") }
      before do        
        put :update, params: { id: job.id, job: attr }
      end

      it "returns http success" do
        expect(response).to have_http_status(:found)
      end

      it "updates job" do
        expect(assigns(:job).title).to eql(attr[:title])
      end
    end

    describe "DELETE #destroy" do
      before do
        delete :destroy, params: { id: job.id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:found)
      end

      it "deletes the requested job" do
        expect(Job.all).to be_empty
      end
    end 
  end
end
