class Movie < ActiveRecord::Base
	def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end
	validates :title, :presence => true
	validates :release_date, :presence => true
	validate :released_1930_or_later # uses custom validator below
	validates :rating, :inclusion => {:in => Movie.all_ratings}, :unless => :grandfathered?
	#Validirace rating samo ako je grandfathered == true, grandfathered je custom validacija

	# Released_1930_or_later custom validation, release_date je pasovan ovoj funkciji jos ne znam kako
	def released_1930_or_later
		:errors.add(:release_date, "must be 1930 or later") if
 		release_date && release_date < Date.parse('1 Jan 1930')
 	end
 	#Note that we first validate the presence of release_date, otherwise the comparisons in lines 10 and 14 could fail if release_date is nil.

 	# Is grandfathered?
 	@@grandfathered_date = Date.parse('1 Nov 1968');
 	def grandfathered?
 		release_date && release_date >= @@grandfathered_date
 	end
end