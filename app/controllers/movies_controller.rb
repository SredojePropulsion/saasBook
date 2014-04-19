# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
	def movie_params
		params.require(:movie).permit(:title,:description,:release_date,:rating)
	end

	#method called when you hit /movies
  	def index
    	@movies = Movie.order(:release_date);
  	end

  	#method called when you hit /movies/3 with GET
 	def show
 		begin
		  @movie = Movie.find(params[:id])
		rescue ActiveRecord::RecordNotFound => e
		  flash[:notice] = "#{params[:id]} does not exist";
		  redirect_to movies_path
		end
 
  		# params[:id] will get id from params, we know it is id because of the route /movies/:id
  		# will render app/views/movies/show.html.haml by default
  	end

  	# default: render 'new' template
  	# Ovde mi je pucalo kad sam hteo da ispisem error, nije mogao da pristupi new objektu
  	# U sustini ovo bi trebalo da bude definisano
  	def new
  		@movie = Movie.new
	end
	# Method for movie creation ... 
	# Create = new + save
	def create
		@movie = Movie.new(movie_params)
		# ASK if object was saved ( Object will not be saved if validation failed )
		# If create or update fails, we use an explicit 'render' to re-render the form so 
		# the user can fill it in again. Conveniently, @movie will be made available to the view 
		# and will hold the values the user entered the first time, so the form will be prepopulated
		# with those values, since (by convention over configuration) the form tag helpers used
		# in _movie_form.html.haml will use @movie to populate the form fields as long as it’s a valid 
		# Movie object.
		if @movie.save
			flash[:notice] = "#{@movie.title} was successfully created."
			redirect_to movies_path
		else
			render 'new' # Object @movie will be accessible in new view so we can repopulate form
			# redirect_to new_movie_path(@movie) ovo ne bi radilo zato sto moramo da posaljemo u sesiji ili
			# kroz flash ( sto se ne radi !!!) zato koristimo reneder
		end
	end

	def edit
		@movie = Movie.find(params[:id])
	end

	def update
		@movie = Movie.find(params[:id])
		if @movie.update_attributes(movie_params)
			flash[:notice] = "#{@movie.title} was successfully updated."
			redirect_to movie_path(@movie)
		else
			render 'edit' # @movie object will be accessible so we can rerender form with values
		end
	end
	def destroy
  		@movie = Movie.find(params[:id])
  		@movie.destroy
  		flash[:notice] = "Movie '#{@movie.title}' deleted."
  		redirect_to movies_path
	end
end