class UpdateInvalidCustomerRefs
  class << self
    def perform
      update_cust_refs(find_all_people_by_array_of_cust_refs(invalid_cust_refs))   
    end

    def new
      raise "Method 'new' not permitted for this class"
    end

    private

    def invalid_cust_refs
      array_cust_refs = []
      command="select person_id, customer_reference, surname, created_at from people where customer_reference like 'T000%' order by created_at asc;"
      Person.connection.execute(command).values.each do |person|
        array_cust_refs << person[1] #customer_reference  
      end
      array_cust_refs
    end

    def find_all_people_by_cust_refs cust_refs_array 
      array_of_people = []
      cust_refs_array.each {|element| array_of_people << Person.find_by_customer_reference(element) }
      array_of_people
    end

    def update_cust_refs people_array
      people_array.each { |person| person.update_attribute(:customer_reference, person.send(:get_customer_reference)) } #unless migrated?
    end

    def migrated?
      ############################
	
    end 
  end
end





##############################################################################################################################################
=begin
select person_id, customer_reference, surname, created_at from people where customer_reference like 'T00000%' order by created_at asc;

select count(*) from people where customer_reference is not null 
and customer_reference not like 'T000%';                          --   122,530
select count(*) from people where customer_reference like 'T000%';--     1,418
select count(*) from people where customer_reference is not null; --   123,948
select count(*) from people where customer_reference is null;     -- 6,199,639
select count(*) from people;                                      -- 6,323,587
=end

#git diff b573ed96af017a808c70ce09f1a0a88457e1a9b0^ a02134de124a476b374ca1285428dfb729522f9c
